import { PartialType } from "@nestjs/swagger"
import { PublishState } from "@prisma/client"
import { IsInt, IsString, Matches, MaxLength } from "class-validator"
import { CreateVideoDto } from "./create-video.dto"

export class UpdateVideoDto extends PartialType(CreateVideoDto) {
  @IsString()
  @MaxLength(1000)
  descMarkdown: string

  @IsString()
  @Matches(
    `^${Object.values(PublishState)
      .filter((v) => typeof v !== "number")
      .join("|")}$`,
    "i"
  )
  availability: string

  crewMembers: string[]
}

export class VideoProgressDto {
  @IsString()
  status: string

  @IsInt()
  jobPercentComplete: number

  @IsString()
  uploadedFilename: string
}
