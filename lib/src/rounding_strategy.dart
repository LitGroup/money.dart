// (c) 2016 Roman Shamritskiy <roman@litgroup.ru>
// This source file is subject to the MIT license that is bundled
// with this source code in the file LICENSE.

part of ru.litgroup.money;

enum RoundingStrategy {
  // TODO (sharom): Add documentation.
  halfUp,
  halfDown,
  halfEve,
  halfOdd,
  up,
  down,
  halfPositiveInf,
  halfNegativeInf
}
