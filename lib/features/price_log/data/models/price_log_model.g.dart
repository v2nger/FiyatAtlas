// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price_log_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPriceLogIsarEntryCollection on Isar {
  IsarCollection<PriceLogIsarEntry> get priceLogIsarEntrys => this.collection();
}

const PriceLogIsarEntrySchema = CollectionSchema(
  name: r'PriceLogIsarEntry',
  id: -20230206123456789, // Manually fixed safe integer for JS
  properties: {
    r'currency': PropertySchema(
      id: 0,
      name: r'currency',
      type: IsarType.string,
    ),
    r'deviceHash': PropertySchema(
      id: 1,
      name: r'deviceHash',
      type: IsarType.string,
    ),
    r'hasReceipt': PropertySchema(
      id: 2,
      name: r'hasReceipt',
      type: IsarType.bool,
    ),
    r'isAvailable': PropertySchema(
      id: 3,
      name: r'isAvailable',
      type: IsarType.bool,
    ),
    r'marketId': PropertySchema(
      id: 4,
      name: r'marketId',
      type: IsarType.string,
    ),
    r'marketName': PropertySchema(
      id: 5,
      name: r'marketName',
      type: IsarType.string,
    ),
    r'price': PropertySchema(
      id: 6,
      name: r'price',
      type: IsarType.double,
    ),
    r'productId': PropertySchema(
      id: 7,
      name: r'productId',
      type: IsarType.string,
    ),
    r'receiptImageUrl': PropertySchema(
      id: 8,
      name: r'receiptImageUrl',
      type: IsarType.string,
    ),
    r'receiptRawText': PropertySchema(
      id: 9,
      name: r'receiptRawText',
      type: IsarType.string,
    ),
    r'syncStatus': PropertySchema(
      id: 10,
      name: r'syncStatus',
      type: IsarType.byte,
      enumMap: _PriceLogIsarEntrysyncStatusEnumValueMap,
    ),
    r'timestamp': PropertySchema(
      id: 11,
      name: r'timestamp',
      type: IsarType.dateTime,
    ),
    r'userId': PropertySchema(
      id: 12,
      name: r'userId',
      type: IsarType.string,
    ),
    r'uuid': PropertySchema(
      id: 13,
      name: r'uuid',
      type: IsarType.string,
    )
  },
  estimateSize: _priceLogIsarEntryEstimateSize,
  serialize: _priceLogIsarEntrySerialize,
  deserialize: _priceLogIsarEntryDeserialize,
  deserializeProp: _priceLogIsarEntryDeserializeProp,
  idName: r'id',
  indexes: {
    r'uuid': IndexSchema(
      id: 2134397340427724972,
      name: r'uuid',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'uuid',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'productId': IndexSchema(
      id: 5580769080710688203,
      name: r'productId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'productId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _priceLogIsarEntryGetId,
  getLinks: _priceLogIsarEntryGetLinks,
  attach: _priceLogIsarEntryAttach,
  version: '3.1.0+1',
);

int _priceLogIsarEntryEstimateSize(
  PriceLogIsarEntry object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.currency.length * 3;
  bytesCount += 3 + object.deviceHash.length * 3;
  bytesCount += 3 + object.marketId.length * 3;
  {
    final value = object.marketName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.productId.length * 3;
  {
    final value = object.receiptImageUrl;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.receiptRawText;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.userId.length * 3;
  bytesCount += 3 + object.uuid.length * 3;
  return bytesCount;
}

void _priceLogIsarEntrySerialize(
  PriceLogIsarEntry object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.currency);
  writer.writeString(offsets[1], object.deviceHash);
  writer.writeBool(offsets[2], object.hasReceipt);
  writer.writeBool(offsets[3], object.isAvailable);
  writer.writeString(offsets[4], object.marketId);
  writer.writeString(offsets[5], object.marketName);
  writer.writeDouble(offsets[6], object.price);
  writer.writeString(offsets[7], object.productId);
  writer.writeString(offsets[8], object.receiptImageUrl);
  writer.writeString(offsets[9], object.receiptRawText);
  writer.writeByte(offsets[10], object.syncStatus.index);
  writer.writeDateTime(offsets[11], object.timestamp);
  writer.writeString(offsets[12], object.userId);
  writer.writeString(offsets[13], object.uuid);
}

PriceLogIsarEntry _priceLogIsarEntryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PriceLogIsarEntry();
  object.currency = reader.readString(offsets[0]);
  object.deviceHash = reader.readString(offsets[1]);
  object.hasReceipt = reader.readBool(offsets[2]);
  object.id = id;
  object.isAvailable = reader.readBool(offsets[3]);
  object.marketId = reader.readString(offsets[4]);
  object.marketName = reader.readStringOrNull(offsets[5]);
  object.price = reader.readDouble(offsets[6]);
  object.productId = reader.readString(offsets[7]);
  object.receiptImageUrl = reader.readStringOrNull(offsets[8]);
  object.receiptRawText = reader.readStringOrNull(offsets[9]);
  object.syncStatus = _PriceLogIsarEntrysyncStatusValueEnumMap[
          reader.readByteOrNull(offsets[10])] ??
      SyncStatus.synced;
  object.timestamp = reader.readDateTime(offsets[11]);
  object.userId = reader.readString(offsets[12]);
  object.uuid = reader.readString(offsets[13]);
  return object;
}

P _priceLogIsarEntryDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readDouble(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (_PriceLogIsarEntrysyncStatusValueEnumMap[
              reader.readByteOrNull(offset)] ??
          SyncStatus.synced) as P;
    case 11:
      return (reader.readDateTime(offset)) as P;
    case 12:
      return (reader.readString(offset)) as P;
    case 13:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _PriceLogIsarEntrysyncStatusEnumValueMap = {
  'synced': 0,
  'pending': 1,
  'failed': 2,
};
const _PriceLogIsarEntrysyncStatusValueEnumMap = {
  0: SyncStatus.synced,
  1: SyncStatus.pending,
  2: SyncStatus.failed,
};

Id _priceLogIsarEntryGetId(PriceLogIsarEntry object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _priceLogIsarEntryGetLinks(
    PriceLogIsarEntry object) {
  return [];
}

void _priceLogIsarEntryAttach(
    IsarCollection<dynamic> col, Id id, PriceLogIsarEntry object) {
  object.id = id;
}

extension PriceLogIsarEntryByIndex on IsarCollection<PriceLogIsarEntry> {
  Future<PriceLogIsarEntry?> getByUuid(String uuid) {
    return getByIndex(r'uuid', [uuid]);
  }

  PriceLogIsarEntry? getByUuidSync(String uuid) {
    return getByIndexSync(r'uuid', [uuid]);
  }

  Future<bool> deleteByUuid(String uuid) {
    return deleteByIndex(r'uuid', [uuid]);
  }

  bool deleteByUuidSync(String uuid) {
    return deleteByIndexSync(r'uuid', [uuid]);
  }

  Future<List<PriceLogIsarEntry?>> getAllByUuid(List<String> uuidValues) {
    final values = uuidValues.map((e) => [e]).toList();
    return getAllByIndex(r'uuid', values);
  }

  List<PriceLogIsarEntry?> getAllByUuidSync(List<String> uuidValues) {
    final values = uuidValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'uuid', values);
  }

  Future<int> deleteAllByUuid(List<String> uuidValues) {
    final values = uuidValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'uuid', values);
  }

  int deleteAllByUuidSync(List<String> uuidValues) {
    final values = uuidValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'uuid', values);
  }

  Future<Id> putByUuid(PriceLogIsarEntry object) {
    return putByIndex(r'uuid', object);
  }

  Id putByUuidSync(PriceLogIsarEntry object, {bool saveLinks = true}) {
    return putByIndexSync(r'uuid', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByUuid(List<PriceLogIsarEntry> objects) {
    return putAllByIndex(r'uuid', objects);
  }

  List<Id> putAllByUuidSync(List<PriceLogIsarEntry> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'uuid', objects, saveLinks: saveLinks);
  }
}

extension PriceLogIsarEntryQueryWhereSort
    on QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QWhere> {
  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PriceLogIsarEntryQueryWhere
    on QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QWhereClause> {
  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterWhereClause>
      uuidEqualTo(String uuid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'uuid',
        value: [uuid],
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterWhereClause>
      uuidNotEqualTo(String uuid) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uuid',
              lower: [],
              upper: [uuid],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uuid',
              lower: [uuid],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uuid',
              lower: [uuid],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uuid',
              lower: [],
              upper: [uuid],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterWhereClause>
      productIdEqualTo(String productId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'productId',
        value: [productId],
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterWhereClause>
      productIdNotEqualTo(String productId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'productId',
              lower: [],
              upper: [productId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'productId',
              lower: [productId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'productId',
              lower: [productId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'productId',
              lower: [],
              upper: [productId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension PriceLogIsarEntryQueryFilter
    on QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QFilterCondition> {
  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      currencyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      currencyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      currencyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      currencyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currency',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      currencyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      currencyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      currencyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      currencyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'currency',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      currencyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currency',
        value: '',
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      currencyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'currency',
        value: '',
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      deviceHashEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deviceHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      deviceHashGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'deviceHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      deviceHashLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'deviceHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      deviceHashBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'deviceHash',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      deviceHashStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'deviceHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      deviceHashEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'deviceHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      deviceHashContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'deviceHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      deviceHashMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'deviceHash',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      deviceHashIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deviceHash',
        value: '',
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      deviceHashIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'deviceHash',
        value: '',
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      hasReceiptEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hasReceipt',
        value: value,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      isAvailableEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isAvailable',
        value: value,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      marketIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'marketId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      marketIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'marketId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      marketIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'marketId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      marketIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'marketId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      marketIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'marketId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      marketIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'marketId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      marketIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'marketId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      marketIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'marketId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      marketIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'marketId',
        value: '',
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      marketIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'marketId',
        value: '',
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      marketNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'marketName',
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      marketNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'marketName',
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      marketNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'marketName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      marketNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'marketName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      marketNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'marketName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      marketNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'marketName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      marketNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'marketName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      marketNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'marketName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      marketNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'marketName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      marketNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'marketName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      marketNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'marketName',
        value: '',
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      marketNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'marketName',
        value: '',
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      priceEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'price',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      priceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'price',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      priceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'price',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      priceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'price',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      productIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'productId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      productIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'productId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      productIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'productId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      productIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'productId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      productIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'productId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      productIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'productId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      productIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'productId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      productIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'productId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      productIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'productId',
        value: '',
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      productIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'productId',
        value: '',
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      receiptImageUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'receiptImageUrl',
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      receiptImageUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'receiptImageUrl',
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      receiptImageUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'receiptImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      receiptImageUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'receiptImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      receiptImageUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'receiptImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      receiptImageUrlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'receiptImageUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      receiptImageUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'receiptImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      receiptImageUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'receiptImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      receiptImageUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'receiptImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      receiptImageUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'receiptImageUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      receiptImageUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'receiptImageUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      receiptImageUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'receiptImageUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      receiptRawTextIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'receiptRawText',
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      receiptRawTextIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'receiptRawText',
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      receiptRawTextEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'receiptRawText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      receiptRawTextGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'receiptRawText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      receiptRawTextLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'receiptRawText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      receiptRawTextBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'receiptRawText',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      receiptRawTextStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'receiptRawText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      receiptRawTextEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'receiptRawText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      receiptRawTextContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'receiptRawText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      receiptRawTextMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'receiptRawText',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      receiptRawTextIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'receiptRawText',
        value: '',
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      receiptRawTextIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'receiptRawText',
        value: '',
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      syncStatusEqualTo(SyncStatus value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      syncStatusGreaterThan(
    SyncStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'syncStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      syncStatusLessThan(
    SyncStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'syncStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      syncStatusBetween(
    SyncStatus lower,
    SyncStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'syncStatus',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      timestampEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      timestampGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      timestampLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      timestampBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timestamp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      userIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      userIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      userIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      userIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      userIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      userIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      userIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      userIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      userIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: '',
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      userIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userId',
        value: '',
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      uuidEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      uuidGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      uuidLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      uuidBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'uuid',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      uuidStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      uuidEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      uuidContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      uuidMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'uuid',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      uuidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: '',
      ));
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterFilterCondition>
      uuidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'uuid',
        value: '',
      ));
    });
  }
}

extension PriceLogIsarEntryQueryObject
    on QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QFilterCondition> {}

extension PriceLogIsarEntryQueryLinks
    on QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QFilterCondition> {}

extension PriceLogIsarEntryQuerySortBy
    on QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QSortBy> {
  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterSortBy>
      sortByCurrency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currency', Sort.asc);
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterSortBy>
      sortByCurrencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currency', Sort.desc);
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterSortBy>
      sortByDeviceHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceHash', Sort.asc);
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterSortBy>
      sortByDeviceHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceHash', Sort.desc);
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterSortBy>
      sortByHasReceipt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasReceipt', Sort.asc);
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterSortBy>
      sortByHasReceiptDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasReceipt', Sort.desc);
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterSortBy>
      sortByIsAvailable() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAvailable', Sort.asc);
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterSortBy>
      sortByIsAvailableDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAvailable', Sort.desc);
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterSortBy>
      sortByMarketId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'marketId', Sort.asc);
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterSortBy>
      sortByMarketIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'marketId', Sort.desc);
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterSortBy>
      sortByMarketName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'marketName', Sort.asc);
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterSortBy>
      sortByMarketNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'marketName', Sort.desc);
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterSortBy>
      sortByPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'price', Sort.asc);
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterSortBy>
      sortByPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'price', Sort.desc);
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterSortBy>
      sortByProductId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productId', Sort.asc);
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterSortBy>
      sortByProductIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productId', Sort.desc);
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterSortBy>
      sortByReceiptImageUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiptImageUrl', Sort.asc);
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterSortBy>
      sortByReceiptImageUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiptImageUrl', Sort.desc);
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterSortBy>
      sortByReceiptRawText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiptRawText', Sort.asc);
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterSortBy>
      sortByReceiptRawTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiptRawText', Sort.desc);
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterSortBy>
      sortBySyncStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.asc);
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterSortBy>
      sortBySyncStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.desc);
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterSortBy>
      sortByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterSortBy>
      sortByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterSortBy>
      sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterSortBy>
      sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterSortBy>
      sortByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterSortBy>
      sortByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension PriceLogIsarEntryQuerySortThenBy
    on QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QSortThenBy> {
  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterSortBy>
      thenByCurrency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currency', Sort.asc);
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterSortBy>
      thenByCurrencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currency', Sort.desc);
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterSortBy>
      thenByDeviceHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceHash', Sort.asc);
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterSortBy>
      thenByDeviceHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceHash', Sort.desc);
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterSortBy>
      thenByHasReceipt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasReceipt', Sort.asc);
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterSortBy>
      thenByHasReceiptDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasReceipt', Sort.desc);
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterSortBy>
      thenByIsAvailable() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAvailable', Sort.asc);
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterSortBy>
      thenByIsAvailableDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAvailable', Sort.desc);
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterSortBy>
      thenByMarketId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'marketId', Sort.asc);
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterSortBy>
      thenByMarketIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'marketId', Sort.desc);
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterSortBy>
      thenByMarketName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'marketName', Sort.asc);
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterSortBy>
      thenByMarketNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'marketName', Sort.desc);
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterSortBy>
      thenByPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'price', Sort.asc);
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterSortBy>
      thenByPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'price', Sort.desc);
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterSortBy>
      thenByProductId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productId', Sort.asc);
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterSortBy>
      thenByProductIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productId', Sort.desc);
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterSortBy>
      thenByReceiptImageUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiptImageUrl', Sort.asc);
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterSortBy>
      thenByReceiptImageUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiptImageUrl', Sort.desc);
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterSortBy>
      thenByReceiptRawText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiptRawText', Sort.asc);
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterSortBy>
      thenByReceiptRawTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiptRawText', Sort.desc);
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterSortBy>
      thenBySyncStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.asc);
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterSortBy>
      thenBySyncStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.desc);
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterSortBy>
      thenByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterSortBy>
      thenByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterSortBy>
      thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterSortBy>
      thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterSortBy>
      thenByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QAfterSortBy>
      thenByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension PriceLogIsarEntryQueryWhereDistinct
    on QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QDistinct> {
  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QDistinct>
      distinctByCurrency({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currency', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QDistinct>
      distinctByDeviceHash({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deviceHash', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QDistinct>
      distinctByHasReceipt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hasReceipt');
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QDistinct>
      distinctByIsAvailable() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isAvailable');
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QDistinct>
      distinctByMarketId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'marketId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QDistinct>
      distinctByMarketName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'marketName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QDistinct>
      distinctByPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'price');
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QDistinct>
      distinctByProductId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'productId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QDistinct>
      distinctByReceiptImageUrl({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'receiptImageUrl',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QDistinct>
      distinctByReceiptRawText({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'receiptRawText',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QDistinct>
      distinctBySyncStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncStatus');
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QDistinct>
      distinctByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timestamp');
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QDistinct>
      distinctByUserId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QDistinct> distinctByUuid(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uuid', caseSensitive: caseSensitive);
    });
  }
}

extension PriceLogIsarEntryQueryProperty
    on QueryBuilder<PriceLogIsarEntry, PriceLogIsarEntry, QQueryProperty> {
  QueryBuilder<PriceLogIsarEntry, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PriceLogIsarEntry, String, QQueryOperations> currencyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currency');
    });
  }

  QueryBuilder<PriceLogIsarEntry, String, QQueryOperations>
      deviceHashProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deviceHash');
    });
  }

  QueryBuilder<PriceLogIsarEntry, bool, QQueryOperations> hasReceiptProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hasReceipt');
    });
  }

  QueryBuilder<PriceLogIsarEntry, bool, QQueryOperations>
      isAvailableProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isAvailable');
    });
  }

  QueryBuilder<PriceLogIsarEntry, String, QQueryOperations> marketIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'marketId');
    });
  }

  QueryBuilder<PriceLogIsarEntry, String?, QQueryOperations>
      marketNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'marketName');
    });
  }

  QueryBuilder<PriceLogIsarEntry, double, QQueryOperations> priceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'price');
    });
  }

  QueryBuilder<PriceLogIsarEntry, String, QQueryOperations>
      productIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'productId');
    });
  }

  QueryBuilder<PriceLogIsarEntry, String?, QQueryOperations>
      receiptImageUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'receiptImageUrl');
    });
  }

  QueryBuilder<PriceLogIsarEntry, String?, QQueryOperations>
      receiptRawTextProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'receiptRawText');
    });
  }

  QueryBuilder<PriceLogIsarEntry, SyncStatus, QQueryOperations>
      syncStatusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncStatus');
    });
  }

  QueryBuilder<PriceLogIsarEntry, DateTime, QQueryOperations>
      timestampProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timestamp');
    });
  }

  QueryBuilder<PriceLogIsarEntry, String, QQueryOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }

  QueryBuilder<PriceLogIsarEntry, String, QQueryOperations> uuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uuid');
    });
  }
}
