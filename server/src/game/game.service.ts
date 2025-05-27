import { Injectable } from "@nestjs/common"
import { ProcessState } from "@prisma/client"
import { PrismaService } from "src/prisma/prisma.service"

@Injectable()
export class GameService {
  constructor(private readonly prisma: PrismaService) {}

  async userLogin(name: string) {
    const session = await this.prisma.session.findFirst({
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
      const towerPlaces = session.players.map((player) => player.towerPlace)
      const possiblePlaces = [5, 7, 11]
      return await this.prisma.user.create({
        data: {
          name,
          session: {
            connect: {
              id: session.id,
            },
          },
          towerPlace: possiblePlaces.find((place) => !towerPlaces.includes(place)),
        },
      })
    }
    return user
  }

  async getSession() {
    return this.prisma.session.findFirst({
      include: {
        players: true,
        usedChoiceGames: true,
        usedTipGames: true,
      },
    })
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
