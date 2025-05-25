import { CacheModule } from "@nestjs/cache-manager"
import { Module } from "@nestjs/common"
import { ConfigModule } from "@nestjs/config"
import { EventEmitterModule } from "@nestjs/event-emitter"
import * as Joi from "joi"
import { AppController } from "./app.controller"
import { GameModule } from "./game/game.module"
import { PrismaModule } from "./prisma/prisma.module"

@Module({
  imports: [
    CacheModule.register(),
    ConfigModule.forRoot(),
    PrismaModule,
    EventEmitterModule.forRoot(),
    ConfigModule.forRoot({
      isGlobal: true,
      validationSchema: Joi.object({
        PORT: Joi.number().default(3000),
        POSTGRES_PRISMA_URL: Joi.string().required(),
      }),
    }),
    GameModule,
  ],
  controllers: [AppController],
  providers: [],
})
export class AppModule {}
