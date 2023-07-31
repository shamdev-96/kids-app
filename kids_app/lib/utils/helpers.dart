import 'dart:math';

class Helpers
{
  static int getRandomPin()
  {
   Random random =  Random();
   int randomNumber = random.nextInt(9999);
   return randomNumber;
  }
}