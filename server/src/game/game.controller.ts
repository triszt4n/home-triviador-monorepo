import { Body, Controller, Get, Logger, Post } from "@nestjs/common"
import { GameService } from "./game.service"

@Controller("game")
export class GameController {
  constructor(private readonly gameService: GameService) {}

  // logger:
  private logger = new Logger(GameController.name)

  @Get()
  async get() {
    this.logger.debug("Got session")
    return this.gameService.getSession()
  }

  @Get("status")
  async getStatus() {
    this.logger.debug("Got status")
    return this.gameService.getStatus()
  }

  @Post("reset")
  async resetGame() {
    const res = await this.gameService.reset()
    this.logger.debug("Game reset")
    return res
  }

  @Post("user")
  async userLogin(@Body() createGameDto: { name: string }) {
    const res = await this.gameService.userLogin(createGameDto.name)
    this.logger.debug(`User logged in: ${createGameDto.name} in session: ${res.sessionId}`)
    return res
  }
}
