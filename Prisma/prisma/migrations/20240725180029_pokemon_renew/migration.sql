/*
  Warnings:

  - You are about to drop the column `user_id` on the `pokemon` table. All the data in the column will be lost.
  - You are about to drop the `users` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "pokemon" DROP CONSTRAINT "pokemon_user_id_fkey";

-- AlterTable
ALTER TABLE "pokemon" DROP COLUMN "user_id",
ADD COLUMN     "trainer_id" INTEGER;

-- DropTable
DROP TABLE "users";

-- CreateTable
CREATE TABLE "trainers" (
    "trainer_id" SERIAL NOT NULL,
    "email" TEXT NOT NULL,
    "username" TEXT NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "trainers_pkey" PRIMARY KEY ("trainer_id")
);

-- CreateIndex
CREATE UNIQUE INDEX "trainers_email_key" ON "trainers"("email");

-- CreateIndex
CREATE UNIQUE INDEX "trainers_username_key" ON "trainers"("username");

-- AddForeignKey
ALTER TABLE "pokemon" ADD CONSTRAINT "pokemon_trainer_id_fkey" FOREIGN KEY ("trainer_id") REFERENCES "trainers"("trainer_id") ON DELETE CASCADE ON UPDATE CASCADE;
