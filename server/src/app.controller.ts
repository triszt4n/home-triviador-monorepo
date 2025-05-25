import { Controller, Get, HttpCode } from "@nestjs/common"

@Controller()
export class AppController {
  @Get()
  getHello(): string {
    return "Hello World!"
  }

  @Get("health")
  @HttpCode(204)
  health(): string {
    return "No content"
  }
}
