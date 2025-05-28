import { Injectable } from "@nestjs/common"
import { ProcessState } from "@prisma/client"
import { PrismaService } from "src/prisma/prisma.service"

@Injectable()
export class GameService {
  constructor(private readonly prisma: PrismaService) {}

  async userLogin(name: string) {
    let session = await this.prisma.session.findFirst({
      include: {
        players: true,
      },
    })
    const user = await this.prisma.user.findFirst({
      where: {
        name,
      },
    })
    if (!user && session.players.length < 3) {
      const towerPlaces = session.players.map((player) => player.conqueredPlaces).flat()
      const possiblePlaces = [5, 7, 11]
      return await this.prisma.user.create({
        data: {
          name,
          session: {
            connect: {
              id: session.id,
            },
          },
          conqueredPlaces: [possiblePlaces.find((place) => !towerPlaces.includes(place))],
        },
      })
    }

    session = await this.prisma.session.findFirst({
      include: {
        players: true,
      },
    })
    if (session.state === ProcessState.UNSTARTED && session.players.length == 3) {
      await this.prisma.session.update({
        where: {
          id: session.id,
        },
        data: {
          state: ProcessState.STARTED,
        },
      })
    }

    return user
  }

  async getSession() {
    return this.prisma.session.findFirst({
      include: {
        players: {
          orderBy: {
            id: "asc",
          },
        },
      },
    })
  }

  async getStatus(): Promise<{ phase: number; message: string }> {
    const session = await this.prisma.session.findFirst({
      include: {
        players: {
          orderBy: {
            id: "asc",
          },
        },
      },
    })

    if (session.state === ProcessState.UNSTARTED) {
      return {
        phase: -1,
        message: "Waiting for players to join...",
      }
    }
    if (session.state === ProcessState.FINISHED) {
      const winnerByPoints = session.players.reduce((prev, current) => {
        return prev.points > current.points ? prev : current
      })
      return {
        phase: 100,
        message: `Winner: "${winnerByPoints.name}"`,
      }
    }

    // 0-6: tip0-6, 7-18: choice0-11
    if ([0, 1, 2, 3, 4, 5, 6].includes(session.phase)) {
      return {
        phase: session.phase,
        message: `[${session.phase}] Guess quickly!`,
      }
    }
    if ([7, 12, 14, 18].includes(session.phase)) {
      return {
        phase: session.phase,
        message: `[${session.phase}] Player "${session.players[0].name}" attacks.`,
      }
    }
    if ([8, 10, 15, 17].includes(session.phase)) {
      return {
        phase: session.phase,
        message: `[${session.phase}] Player "${session.players[1].name}" attacks.`,
      }
    }
    if ([9, 11, 13, 16].includes(session.phase)) {
      return {
        phase: session.phase,
        message: `[${session.phase}] Player "${session.players[2].name}" attacks.`,
      }
    }
  }

  async reset() {
    const session = await this.prisma.session.findFirst()
    await this.prisma.user.deleteMany({
      where: {
        sessionId: session.id,
      },
    })
    await this.prisma.incoming.deleteMany()
    return this.prisma.session.update({
      where: {
        id: session.id,
      },
      data: {
        state: ProcessState.UNSTARTED,
        players: {
          set: [],
        },
      },
    })
  }

  async getNextTip() {
    const session = await this.prisma.session.findFirst({
      include: { currentTipGame: true },
    })
    if (session.currentTipGame) return session.currentTipGame

    const tipGame = await this.prisma.tipGame.findFirst({
      where: {
        used: false,
      },
    })
    if (!tipGame) {
      throw new Error("No available tip game found")
    }
    await this.prisma.tipGame.update({
      where: {
        id: tipGame.id,
      },
      data: {
        used: true,
      },
    })
    await this.prisma.session.update({
      where: {
        id: session.id,
      },
      data: {
        currentTipGame: {
          connect: {
            id: tipGame.id,
          },
        },
      },
    })
    return tipGame
  }

  async postTip(name: string, tip: number, tipGameId: string) {
    const session = await this.prisma.session.findFirst({
      include: {
        players: true,
      },
    })
    const player = session.players.find((player) => player.name === name)
    if (!player) {
      throw new Error("Player not found")
    }
    const tipGame = await this.prisma.tipGame.findFirst({
      where: {
        id: tipGameId,
      },
    })
    if (!tipGame) {
      throw new Error("Tip game not found")
    }
    return this.prisma.tipGame.update({
      where: {
        id: tipGame.id,
      },
      data: {
        incomingTips: {
          create: {
            playerId: player.id,
            tip,
          },
        },
      },
    })
  }

  async getResults() {
    const session = await this.prisma.session.findFirst({
      include: {
        currentTipGame: {
          include: {
            incomingTips: {
              include: {
                player: true,
              },
            },
          },
        },
      },
    })
    const tipGame = session.currentTipGame
    if (!tipGame) {
      throw new Error("Tip game not found")
    }

    // winner is the closest to the tip and fastest
    if (tipGame.incomingTips.length === 3) {
      const sortedTips = tipGame.incomingTips.sort((a, b) => {
        const diffA = Math.abs(tipGame.tip - a.tip)
        const diffB = Math.abs(tipGame.tip - b.tip)
        if (diffA === diffB) {
          return a.createdAt.getTime() - b.createdAt.getTime()
        }
        return diffA - diffB
      })
      const incomingTips = sortedTips.map((tip, index) => ({
        name: tip.player.name,
        tip: tip.tip,
        ranking: index,
      }))
      await this.prisma.session.update({
        where: {
          id: session.id,
        },
        data: {
          currentTipGame: {
            disconnect: true,
          },
        },
      })
      return {
        incomingTips: incomingTips,
        winningTip: tipGame.tip,
      }
    }

    return {
      incomingTips: [],
      winningTip: tipGame.tip,
    }
  }

  async conquer(name: string, place: number) {
    const session = await this.prisma.session.findFirst({
      include: {
        players: true,
      },
    })
    if (!session) {
      throw new Error("Session not found")
    }
    const player = session.players.find((player) => player.name === name)
    if (!player) {
      throw new Error("Player not found")
    }
    if (player.conqueredPlaces.includes(place)) {
      return
    }
    return this.prisma.user.update({
      where: {
        id: player.id,
      },
      data: {
        conqueredPlaces: [...player.conqueredPlaces, place],
      },
    })
  }
}
