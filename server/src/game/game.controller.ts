import { Body, Controller, Post } from "@nestjs/common"
import { GameService } from "./game.service"

@Controller("game")
export class GameController {
  constructor(private readonly gameService: GameService) {}

  @Post("userLogin")
  userLogin(@Body() createGameDto: { name: string }) {
    return this.gameService.userLogin(createGameDto.name)
  }
}
