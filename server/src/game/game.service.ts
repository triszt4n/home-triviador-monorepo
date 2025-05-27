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
}
