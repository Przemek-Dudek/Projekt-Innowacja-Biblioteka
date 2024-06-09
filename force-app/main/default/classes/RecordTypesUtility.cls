public with sharing class RecordTypesUtility {
    public static Map<String,RecordTypeInfo> recordTypeMap { get; private set; }

    public static Id getRecordTypeId(SobjectType objectType, String recordTypeName) {
        if(recordTypeMap == null) {
            recordTypeMap = new Map<String,RecordTypeInfo>();
        }
        String objectName = objectType.getDescribe().getName();
        if(!recordTypeMap.containsKey(objectName+recordTypeName)) {
            for(RecordTypeInfo recordTypeInfo : objectType.getDescribe().getRecordTypeInfosByName().values()) {
                recordTypeMap.put(objectName+recordTypeInfo.getName(), recordTypeInfo);
            }
        }
        return recordTypeMap.get(objectName+recordTypeName).getRecordTypeId(); 
    }

}