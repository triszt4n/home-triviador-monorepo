/*
  Warnings:

  - You are about to drop the column `incomingAnswers` on the `ChoiceGame` table. All the data in the column will be lost.
  - You are about to drop the column `incomingTips` on the `TipGame` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "ChoiceGame" DROP COLUMN "incomingAnswers";

-- AlterTable
ALTER TABLE "TipGame" DROP COLUMN "incomingTips";

-- CreateTable
CREATE TABLE "Incoming" (
    "id" TEXT NOT NULL,
    "playerId" TEXT NOT NULL,
    "tip" INTEGER NOT NULL,

    CONSTRAINT "Incoming_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_ChoiceGameToIncoming" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "_IncomingToTipGame" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "_ChoiceGameToIncoming_AB_unique" ON "_ChoiceGameToIncoming"("A", "B");

-- CreateIndex
CREATE INDEX "_ChoiceGameToIncoming_B_index" ON "_ChoiceGameToIncoming"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_IncomingToTipGame_AB_unique" ON "_IncomingToTipGame"("A", "B");

-- CreateIndex
CREATE INDEX "_IncomingToTipGame_B_index" ON "_IncomingToTipGame"("B");

-- AddForeignKey
ALTER TABLE "Incoming" ADD CONSTRAINT "Incoming_playerId_fkey" FOREIGN KEY ("playerId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_ChoiceGameToIncoming" ADD CONSTRAINT "_ChoiceGameToIncoming_A_fkey" FOREIGN KEY ("A") REFERENCES "ChoiceGame"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_ChoiceGameToIncoming" ADD CONSTRAINT "_ChoiceGameToIncoming_B_fkey" FOREIGN KEY ("B") REFERENCES "Incoming"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_IncomingToTipGame" ADD CONSTRAINT "_IncomingToTipGame_A_fkey" FOREIGN KEY ("A") REFERENCES "Incoming"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_IncomingToTipGame" ADD CONSTRAINT "_IncomingToTipGame_B_fkey" FOREIGN KEY ("B") REFERENCES "TipGame"("id") ON DELETE CASCADE ON UPDATE CASCADE;
