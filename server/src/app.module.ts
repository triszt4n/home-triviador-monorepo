import { CacheModule } from "@nestjs/cache-manager"
import { Module } from "@nestjs/common"
import { ConfigModule } from "@nestjs/config"
import { EventEmitterModule } from "@nestjs/event-emitter"
import { AppController } from "./app.controller"
import { AuthModule } from "./auth/auth.module"
import { PrismaModule } from "./prisma/prisma.module"
import { UsersModule } from "./users/users.module"
import { VideoModule } from "./video/video.module"
import { GameModule } from './game/game.module';
import * as Joi from "joi"

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
        FRONTEND_CALLBACK: Joi.string().required(),
        JWT_SECRET: Joi.string().required(),
        POSTGRES_PRISMA_URL: Joi.string().required(),
        AUTHSCH_CLIENT_ID: Joi.string().required(),
        AUTHSCH_CLIENT_SECRET: Joi.string().required(),
      }),
    }),
    AuthModule,
    UsersModule,
    VideoModule,
    GameModule,
  ],
  controllers: [AppController],
  providers: [],
})
export class AppModule {}
