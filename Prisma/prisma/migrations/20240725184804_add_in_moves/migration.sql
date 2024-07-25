-- CreateTable
CREATE TABLE "moves" (
    "move_id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "moves_pkey" PRIMARY KEY ("move_id")
);

-- CreateTable
CREATE TABLE "pokemon_moves" (
    "pokemon_move_id" SERIAL NOT NULL,
    "pokemon_id" INTEGER NOT NULL,
    "move_id" INTEGER NOT NULL,
    "added_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "pokemon_moves_pkey" PRIMARY KEY ("pokemon_move_id")
);

-- CreateIndex
CREATE UNIQUE INDEX "pokemon_moves_pokemon_id_move_id_key" ON "pokemon_moves"("pokemon_id", "move_id");

-- AddForeignKey
ALTER TABLE "pokemon_moves" ADD CONSTRAINT "pokemon_moves_pokemon_id_fkey" FOREIGN KEY ("pokemon_id") REFERENCES "pokemon"("post_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "pokemon_moves" ADD CONSTRAINT "pokemon_moves_move_id_fkey" FOREIGN KEY ("move_id") REFERENCES "moves"("move_id") ON DELETE CASCADE ON UPDATE CASCADE;
