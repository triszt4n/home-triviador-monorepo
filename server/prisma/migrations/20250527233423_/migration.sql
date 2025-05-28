/*
  Warnings:

  - You are about to drop the `_ChoiceGameToIncoming` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `_IncomingToTipGame` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "_ChoiceGameToIncoming" DROP CONSTRAINT "_ChoiceGameToIncoming_A_fkey";

-- DropForeignKey
ALTER TABLE "_ChoiceGameToIncoming" DROP CONSTRAINT "_ChoiceGameToIncoming_B_fkey";

-- DropForeignKey
ALTER TABLE "_IncomingToTipGame" DROP CONSTRAINT "_IncomingToTipGame_A_fkey";

-- DropForeignKey
ALTER TABLE "_IncomingToTipGame" DROP CONSTRAINT "_IncomingToTipGame_B_fkey";

-- AlterTable
ALTER TABLE "Incoming" ADD COLUMN     "ChoiceGameid" TEXT,
ADD COLUMN     "TipGameid" TEXT;

-- DropTable
DROP TABLE "_ChoiceGameToIncoming";

-- DropTable
DROP TABLE "_IncomingToTipGame";

-- AddForeignKey
ALTER TABLE "Incoming" ADD CONSTRAINT "Incoming_ChoiceGameid_fkey" FOREIGN KEY ("ChoiceGameid") REFERENCES "ChoiceGame"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Incoming" ADD CONSTRAINT "Incoming_TipGameid_fkey" FOREIGN KEY ("TipGameid") REFERENCES "TipGame"("id") ON DELETE SET NULL ON UPDATE CASCADE;
