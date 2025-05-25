import { PutObjectCommand, S3Client } from "@aws-sdk/client-s3"
import { Injectable } from "@nestjs/common"
import { ConfigService } from "@nestjs/config"
import { ProcessState } from "@prisma/client"
import { UserDto } from "src/auth/dto/user.dto"
import { PrismaService } from "src/prisma/prisma.service"
import { CreateVideoDto } from "./dto/create-video.dto"
import { UpdateVideoDto, VideoProgressDto } from "./dto/update-video.dto"

@Injectable()
export class VideoService {
  constructor(
    private readonly configService: ConfigService,
    private readonly prisma: PrismaService
  ) {}

  private readonly s3Client = new S3Client({
    region: this.configService.getOrThrow("AWS_S3_REGION"),
  })

  async create(createVideoDto: CreateVideoDto, user: UserDto) {
    const viewCounter = await this.prisma.viewCounter.create({
      data: {},
    })

    return this.prisma.vod.create({
      data: {
        title: createVideoDto.title,
        descMarkdown: "",
        author: {
          connect: {
            id: user.id,
          },
        },
        viewCounter: {
          connect: {
            id: viewCounter.id,
          },
        },
      },
    })
  }

  async upload(id: string, fileName: string, file: Buffer) {
    const ext = fileName.split(".").slice(-1)[0]
    const baseName = new Date().toISOString().slice(0, 19).replaceAll(":", "-")

    const response = await this.s3Client.send(
      new PutObjectCommand({
        Bucket: this.configService.getOrThrow("AWS_S3_UPLOADED_BUCKET"),
        Key: `${id}/${baseName}.${ext}`,
        Body: file,
      })
    )
    return {
      ...response,
      fileName: `${baseName}.${ext}`,
    }
  }

  async afterUpload(id: string, fileName: string) {
    return this.prisma.vod.update({
      where: {
        id,
      },
      data: {
        uploadedFilename: fileName,
        state: ProcessState.UPLOADED,
      },
    })
  }

  async findAll() {
    return this.prisma.vod.findMany({
      include: {
        author: true,
      },
    })
  }

  async findOne(id: string) {
    return this.prisma.vod.findUnique({
      where: {
        id,
      },
    })
  }

  async update(id: string, updateVideoDto: UpdateVideoDto) {
    return this.prisma.vod.update({
      where: {
        id,
      },
      data: {
        title: updateVideoDto.title,
      },
    })
  }

  async progressUpdate(id: string, videoProgressDto: VideoProgressDto) {
    const statePercent = videoProgressDto.jobPercentComplete
    let state: ProcessState = ProcessState.PROCESSING
    switch (videoProgressDto.status) {
      case "COMPLETE":
        state = ProcessState.PROCESSED
        break
      case "ERROR":
        state = ProcessState.FAILED
        break
    }
    return this.prisma.vod.update({
      where: {
        id,
      },
      data: {
        statePercent,
        state,
      },
    })
  }

  async remove(id: string) {
    return this.prisma.vod.delete({
      where: {
        id,
      },
    })
  }
}
