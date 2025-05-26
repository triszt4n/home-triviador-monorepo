import { PrismaClient } from "@prisma/client"
import * as dotenv from "dotenv"

const prisma = new PrismaClient()

async function seeder() {
  dotenv.config()
  console.debug("Seeding...")
  // TODO: Create a session if not already in the database
  const session = await prisma.session.findFirst()
  if (!session) {
    console.debug("Creating a session...")
    await prisma.session.create({ data: {} })
  }
}

seeder()
  .catch((e) => console.error(e))
  .finally(async () => {
    await prisma.$disconnect()
  })
