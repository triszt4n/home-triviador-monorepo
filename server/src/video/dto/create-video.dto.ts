import { IsString, MinLength } from "class-validator"

export class CreateVideoDto {
  @IsString()
  @MinLength(3)
  title: string
}
