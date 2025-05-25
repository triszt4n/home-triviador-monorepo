import { CurrentUser } from "@kir-dev/passport-authsch"
import { Body, Controller, Delete, Get, Param, ParseFilePipe, Patch, Post, UploadedFile, UseGuards, UseInterceptors } from "@nestjs/common"
import { FileInterceptor } from "@nestjs/platform-express"
import { UserDto } from "src/auth/dto/user.dto"
import { JwtGuard } from "src/auth/guards/jwt.guard"
import { CreateVideoDto } from "./dto/create-video.dto"
import { UpdateVideoDto, VideoProgressDto } from "./dto/update-video.dto"
import { VideoService } from "./video.service"

@Controller("videos")
export class VideoController {
  constructor(private readonly videoService: VideoService) {}

  @Post()
  @UseGuards(JwtGuard)
  async create(@Body() createVideoDto: CreateVideoDto, @CurrentUser() user: UserDto) {
    return this.videoService.create(createVideoDto, user)
  }

  @Post(":id/upload")
  @UseGuards(JwtGuard)
  @UseInterceptors(FileInterceptor("file"))
  async upload(
    @Param("id") id: string,
    @UploadedFile(
      new ParseFilePipe({
        validators: [
          // new MaxFileSizeValidator({ maxSize: 1000 }),
          // new FileTypeValidator({ fileType: 'image/jpeg' }),
        ],
      })
    )
    file: Express.Multer.File
  ) {
    const result = await this.videoService.upload(id, file.originalname, file.buffer)
    return await this.videoService.afterUpload(id, result.fileName)
  }

  @Get()
  findAll() {
    return this.videoService.findAll()
  }

  @Get(":id")
  findOne(@Param("id") id: string) {
    return this.videoService.findOne(id)
  }

  @Patch(":id")
  update(@Param("id") id: string, @Body() updateVideoDto: UpdateVideoDto) {
    return this.videoService.update(id, updateVideoDto)
  }

  @Patch(":id/progress")
  progress(@Param("id") id: string, @Body() videoProgressDto: VideoProgressDto) {
    return this.videoService.progressUpdate(id, videoProgressDto)
  }

  @Delete(":id")
  remove(@Param("id") id: string) {
    return this.videoService.remove(id)
  }
}
