/*
  Warnings:

  - You are about to drop the `trainers` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "pokemon" DROP CONSTRAINT "pokemon_trainer_id_fkey";

-- DropTable
DROP TABLE "trainers";

-- CreateTable
CREATE TABLE "trainer" (
    "trainer_id" SERIAL NOT NULL,
    "email" TEXT NOT NULL,
    "username" TEXT NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "trainer_pkey" PRIMARY KEY ("trainer_id")
);

-- CreateIndex
CREATE UNIQUE INDEX "trainer_email_key" ON "trainer"("email");

-- CreateIndex
CREATE UNIQUE INDEX "trainer_username_key" ON "trainer"("username");

-- AddForeignKey
ALTER TABLE "pokemon" ADD CONSTRAINT "pokemon_trainer_id_fkey" FOREIGN KEY ("trainer_id") REFERENCES "trainer"("trainer_id") ON DELETE CASCADE ON UPDATE CASCADE;
