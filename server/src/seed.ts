import { PrismaClient } from "@prisma/client"
import * as dotenv from "dotenv"

const prisma = new PrismaClient()

async function seeder() {
  dotenv.config()
  console.debug("Seeding...")

  const session = await prisma.session.findFirst()
  if (!session) {
    console.debug("Creating a session...")
    await prisma.session.create({ data: {} })
  }

  const tipGameNumber = await prisma.tipGame.count()
  if (tipGameNumber === 0) {
    console.debug("Creating tip games...")
    const tipGames = [
      { question: "Melyik évben volt Szent István királlyá koronázása?", tip: 1001 },
      { question: "Melyik évben volt a mohácsi csata?", tip: 1526 },
      { question: "Melyik évben volt a trianoni békeszerződés?", tip: 1920 },
      { question: "Melyik évben alakult meg a Magyar Népköztársaság?", tip: 1949 },
      { question: "Melyik évben volt a rendszerváltás Magyarországon?", tip: 1989 },
      { question: "Melyik évben csatlakozott Magyarország az Európai Unióhoz?", tip: 2004 },
      { question: "Melyik évben nyerte meg Magyarország az első olimpiai aranyérmét?", tip: 1896 },
      { question: "Melyik évben indult el Magyarországon az ötöslottó?", tip: 1957 },
      { question: "Hány évig tartott a 100 éves háború?", tip: 116 },
      { question: "Hány forintos bankjegyen található gróf Széchenyi István?", tip: 5000 },
      { question: "Hány éves volt Kossuth Lajos, amikor elhunyt?", tip: 91 },
    ]
    await prisma.tipGame.createMany({ data: tipGames })
  }
  const choiceGameNumber = await prisma.choiceGame.count()
  if (choiceGameNumber === 0) {
    console.debug("Creating choice games...")
    const choiceGames = [
      { question: "Melyik a legnagyobb magyar folyó?", choices: ["Tisza", "Duna", "Dráva", "Zagyva"], answer: 1 },
      { question: "Melyik a legnagyobb magyar tó?", choices: ["Balaton", "Velencei-tó", "Tisza-tó", "Fertő tó"], answer: 0 },
      { question: "Mi az ENSZ székhelye?", choices: ["New York", "Washington", "Brüsszel", "Párizs"], answer: 0 },
      { question: "Melyik király alapította a tihanyi apátságot?", choices: ["I. István", "I. Lajos", "I. Béla", "I. András"], answer: 3 },
      { question: "Kit választottak 2013-ban római pápának?", choices: ["Benedek", "Ferenc", "János Pál", "Pál"], answer: 1 },
      { question: "Ki volt az első római császár?", choices: ["Julius Caesar", "Augustus", "Nero", "Traianus"], answer: 1 },
      { question: "Hol van Bora Bora szigete?", choices: ["Francia Polinézia", "Hawaii", "Bahama-szigetek", "Fidzsi-szigetek"], answer: 0 },
      { question: "Melyik ország fővárosa Hanoi?", choices: ["Thaiföld", "Kambodzsa", "Laosz", "Vietnam"], answer: 3 },
      { question: "Mi a Szent Jakab-út másik elnevezése?", choices: ["El Caminó", "Al Bambinó", "El Diego", "El Dorado"], answer: 0 },
      { question: "Kivel nem énekelt duettet Ákos?", choices: ["Rúzsa Magdival", "Janicsák Vecával", "Tolvai Renátával", "Emiliával"], answer: 2 },
      { question: "Melyik együttes dalai a Dancing Queen és a Waterloo?", choices: ["ABBA", "Bee Gees", "The Beatles", "Queen"], answer: 0 },
      { question: "Kitől ered az operett elnevezés?", choices: ["Johann Strauss", "J. S. Bach", "Guiseppe Verdi", "W. A. Mozart"], answer: 3 },
      { question: "Kik a lajhárok legközelebbi rokonai?", choices: ["Pangolinok", "Hangyászok", "Mosómedvék", "Övesállatok"], answer: 1 },
      { question: "Mennyi a normális vércukorszint?", choices: ["3,5-5,5 mmol/l", "3,9-6,1 mmol/l", "5,0-7,6 mmol/l", "11,0-12,0 mmol/l"], answer: 1 },
      { question: "Hogy hívták Vuk nagybátyját a rajzfilmben?", choices: ["Tas", "Kag", "Karak", "Kobak"], answer: 2 },
      { question: "Melyik városban alakult a Punnany Massif zenekar?", choices: ["Budapest", "Debrecen", "Szeged", "Pécs"], answer: 3 },
      { question: "Hány billió kilométer 1 fényév?", choices: ["1,2", "9,4", "12,3", "15,6"], answer: 1 },
    ]
    await prisma.choiceGame.createMany({ data: choiceGames })
  }
}

seeder()
  .catch((e) => console.error(e))
  .finally(async () => {
    await prisma.$disconnect()
  })
