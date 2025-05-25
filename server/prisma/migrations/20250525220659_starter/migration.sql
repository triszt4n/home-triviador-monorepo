-- CreateEnum
CREATE TYPE "ProcessState" AS ENUM ('UNSTARTED', 'STARTED', 'FINISHED');

-- CreateTable
CREATE TABLE "User" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "number" INTEGER NOT NULL,
    "sessionId" TEXT NOT NULL,
    "towerHealth" INTEGER NOT NULL DEFAULT 3,
    "towerPlace" INTEGER NOT NULL DEFAULT 0,
    "conqueredPlaces" INTEGER[] DEFAULT ARRAY[]::INTEGER[],
    "points" INTEGER NOT NULL DEFAULT 1000,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Session" (
    "id" TEXT NOT NULL,
    "state" "ProcessState" NOT NULL DEFAULT 'UNSTARTED',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Session_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TipGame" (
    "id" TEXT NOT NULL,
    "question" TEXT NOT NULL,
    "tip" INTEGER NOT NULL,

    CONSTRAINT "TipGame_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ChoiceGame" (
    "id" TEXT NOT NULL,
    "question" TEXT NOT NULL,
    "choices" TEXT[],
    "answer" INTEGER NOT NULL,

    CONSTRAINT "ChoiceGame_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "User" ADD CONSTRAINT "User_sessionId_fkey" FOREIGN KEY ("sessionId") REFERENCES "Session"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
