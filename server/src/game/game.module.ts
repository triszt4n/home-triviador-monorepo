import { Module } from "@nestjs/common"
import { PrismaModule } from "src/prisma/prisma.module"
import { GameController } from "./game.controller"
import { GameService } from "./game.service"

@Module({
  controllers: [GameController],
  providers: [GameService],
  imports: [PrismaModule],
})
export class GameModule {}
