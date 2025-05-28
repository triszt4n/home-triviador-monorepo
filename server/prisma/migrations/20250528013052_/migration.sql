/*
  Warnings:

  - You are about to drop the `_ChoiceGameToSession` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `_SessionToTipGame` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "_ChoiceGameToSession" DROP CONSTRAINT "_ChoiceGameToSession_A_fkey";

-- DropForeignKey
ALTER TABLE "_ChoiceGameToSession" DROP CONSTRAINT "_ChoiceGameToSession_B_fkey";

-- DropForeignKey
ALTER TABLE "_SessionToTipGame" DROP CONSTRAINT "_SessionToTipGame_A_fkey";

-- DropForeignKey
ALTER TABLE "_SessionToTipGame" DROP CONSTRAINT "_SessionToTipGame_B_fkey";

-- AlterTable
ALTER TABLE "ChoiceGame" ADD COLUMN     "used" BOOLEAN NOT NULL DEFAULT false;

-- AlterTable
ALTER TABLE "Session" ADD COLUMN     "currentChoiceGameId" TEXT,
ADD COLUMN     "currentTipGameId" TEXT;

-- AlterTable
ALTER TABLE "TipGame" ADD COLUMN     "used" BOOLEAN NOT NULL DEFAULT false;

-- DropTable
DROP TABLE "_ChoiceGameToSession";

-- DropTable
DROP TABLE "_SessionToTipGame";

-- AddForeignKey
ALTER TABLE "Session" ADD CONSTRAINT "Session_currentTipGameId_fkey" FOREIGN KEY ("currentTipGameId") REFERENCES "TipGame"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Session" ADD CONSTRAINT "Session_currentChoiceGameId_fkey" FOREIGN KEY ("currentChoiceGameId") REFERENCES "ChoiceGame"("id") ON DELETE SET NULL ON UPDATE CASCADE;
