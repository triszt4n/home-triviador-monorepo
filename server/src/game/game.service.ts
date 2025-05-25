import { Injectable } from "@nestjs/common"
import { ProcessState } from "@prisma/client"
import { PrismaService } from "src/prisma/prisma.service"

@Injectable()
export class GameService {
  constructor(private readonly prisma: PrismaService) {}

  async userLogin(name: string) {
    const session = await this.prisma.session.findFirst()
    const user = await this.prisma.user.findFirst({
      where: {
        name,
      },
    })
    return user
  }

  async getSession() {
    return this.prisma.session.findFirst()
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
