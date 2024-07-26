/*
  Warnings:

  - You are about to drop the `notification_settings` table. If the table is not empty, all the data it contains will be lost.

*/
-- CreateEnum
CREATE TYPE "TrainerType" AS ENUM ('ACE_TRAINER', 'BUG_CATCHER', 'DRAGON_TAMER', 'FISHERMAN');

-- DropForeignKey
ALTER TABLE "notification_settings" DROP CONSTRAINT "notification_settings_trainer_id_fkey";

-- AlterTable
ALTER TABLE "trainer" ADD COLUMN     "trainerType" "TrainerType"[];

-- DropTable
DROP TABLE "notification_settings";
