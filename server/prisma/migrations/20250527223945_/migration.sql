-- AlterTable
ALTER TABLE "ChoiceGame" ADD COLUMN     "incomingAnswers" INTEGER[] DEFAULT ARRAY[]::INTEGER[];

-- AlterTable
ALTER TABLE "TipGame" ADD COLUMN     "incomingTips" INTEGER[] DEFAULT ARRAY[]::INTEGER[];
