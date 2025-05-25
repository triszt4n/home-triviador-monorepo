import { Injectable } from "@nestjs/common"
import { PrismaService } from "src/prisma/prisma.service"

@Injectable()
export class GameService {
  constructor(private readonly prisma: PrismaService) {}

  userLogin(name: string) {
    const session = this.prisma.session.findFirst()
    const user = this.prisma.user.findFirst({
      where: {
        name,
      },
    })
    if (user) {
      return user
    }
  }

  getSession() {
    return this.prisma.session.findFirst()
  }
}
