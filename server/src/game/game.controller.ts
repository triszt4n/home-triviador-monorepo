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

  @Get("nextTip")
  async getNextTip() {
    this.logger.debug("GET next tip")
    return this.gameService.getNextTip()
  }

  @Get("currentTip")
  async getResults() {
    this.logger.debug("GET tip results")
    return this.gameService.getResults()
  }

  @Post("tip")
  async postTip(@Body() { id, name, tip }: { id: string; name: string; tip: number }) {
    this.logger.debug("POST tip")
    return this.gameService.postTip(name, tip, id)
  }

  @Post("conquer")
  async conquer(@Body() { name, countyIndex }: { name: string; countyIndex: number }) {
    this.logger.debug("POST conquer")
    return this.gameService.conquer(name, countyIndex)
  }
}
