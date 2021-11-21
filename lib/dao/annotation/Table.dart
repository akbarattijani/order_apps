/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

class Table {
  final String tableName;
  final int whenExists;

  const Table(this.tableName, [this.whenExists = 1]);
}