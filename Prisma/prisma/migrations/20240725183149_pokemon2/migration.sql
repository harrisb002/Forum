/*
  Warnings:

  - Made the column `trainer_id` on table `pokemon` required. This step will fail if there are existing NULL values in that column.

*/
-- AlterTable
ALTER TABLE "pokemon" ALTER COLUMN "trainer_id" SET NOT NULL;
