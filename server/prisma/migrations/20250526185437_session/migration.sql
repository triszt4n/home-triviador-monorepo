-- AlterTable
ALTER TABLE "Session" ADD COLUMN     "phase" INTEGER NOT NULL DEFAULT 0;

-- CreateTable
CREATE TABLE "_SessionToTipGame" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "_ChoiceGameToSession" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "_SessionToTipGame_AB_unique" ON "_SessionToTipGame"("A", "B");

-- CreateIndex
CREATE INDEX "_SessionToTipGame_B_index" ON "_SessionToTipGame"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_ChoiceGameToSession_AB_unique" ON "_ChoiceGameToSession"("A", "B");

-- CreateIndex
CREATE INDEX "_ChoiceGameToSession_B_index" ON "_ChoiceGameToSession"("B");

-- AddForeignKey
ALTER TABLE "_SessionToTipGame" ADD CONSTRAINT "_SessionToTipGame_A_fkey" FOREIGN KEY ("A") REFERENCES "Session"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_SessionToTipGame" ADD CONSTRAINT "_SessionToTipGame_B_fkey" FOREIGN KEY ("B") REFERENCES "TipGame"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_ChoiceGameToSession" ADD CONSTRAINT "_ChoiceGameToSession_A_fkey" FOREIGN KEY ("A") REFERENCES "ChoiceGame"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_ChoiceGameToSession" ADD CONSTRAINT "_ChoiceGameToSession_B_fkey" FOREIGN KEY ("B") REFERENCES "Session"("id") ON DELETE CASCADE ON UPDATE CASCADE;
