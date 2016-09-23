/*
A KBase module: WsLargeDataIO
*/

module WsLargeDataIO {

    /* A boolean - 0 for false, 1 for true.
       @range (0, 1)
    */
    typedef int boolean;

    /* Information about an object, including user provided metadata.
    
        objid - the numerical id of the object.
        name - the name of the object.
        type - the type of the object.
        save_date - the save date of the object.
        ver - the version of the object.
        saved_by - the user that saved or copied the object.
        wsid - the id of the workspace containing the object.
        workspace - the name of the workspace containing the object.
        chsum - the md5 checksum of the object.
        size - the size of the object in bytes.
        meta - arbitrary user-supplied metadata about
            the object.

    */
    typedef tuple<int objid, string name, string type, string save_date,
        int version, string saved_by, int wsid, string workspace, string chsum,
        int size, mapping<string, string> meta> object_info;

    /* An object and associated data required for saving.
    
        Required parameters:
        type - the workspace type string for the object. Omit the version
            information to use the latest version.
        data - the object data.
        
        Optional parameters:
        One of an object name or id. If no name or id is provided the name
            will be set to 'auto' with the object id appended as a string,
            possibly with -\d+ appended if that object id already exists as a
            name.
        name - the name of the object.
        objid - the id of the object to save over.
        meta - arbitrary user-supplied metadata for the object,
            not to exceed 16kb; if the object type specifies automatic
            metadata extraction with the 'meta ws' annotation, and your
            metadata name conflicts, then your metadata will be silently
            overwritten.
        hidden - true if this object should not be listed when listing
            workspace objects.
    
    */
    typedef structure {
        string type;
        string data_json_file;
        string name;
        int objid;
        mapping<string, string> meta;
        boolean hidden;
    } ObjectSaveData;
    
    /* Input parameters for the "save_objects" function.
    
        Required parameters:
        id - the numerical ID of the workspace.
        workspace - optional workspace name alternative to id.
        objects - the objects to save.
        
        The object provenance is automatically pulled from the SDK runner.
    */
    typedef structure {
        int id;
        string workspace;
        list<ObjectSaveData> objects;
    } SaveObjectsParams;
    
    /* 
        Save objects to the workspace. Saving over a deleted object undeletes
        it.
    */
    funcdef save_objects(SaveObjectsParams params)
        returns (list<object_info> info) authentication required;

    /* Input parameters for the "get_objects" function.
    
        Required parameters:
        object_refs - a list of object references in the form X/Y/Z, where X is
            the workspace name or id, Y is the object name or id, and Z is the
            (optional) object version. In general, always use ids rather than
            names if possible to avoid race conditions.
        
        Optional parameters:
        ignore_errors - ignore any errors that occur when fetching an object
            and instead insert a null into the returned list.
    */
    typedef structure {
        list<string> object_refs;
        boolean ignore_errors;
    } GetObjectsParams;
    
    /* The data and supplemental info for an object.
    
        UnspecifiedObject data - the object's data or subset data.
        object_info info - information about the object.
    */
    typedef structure {
        string data_json_file;
        object_info info;
    } ObjectData;
    
    /* Results from the get_objects function.
    
        list<ObjectData> data - the returned objects.
    */
    typedef structure {
        list<ObjectData> data;
    } GetObjectsResults;
    
    /* Get objects from the workspace. */
    funcdef get_objects(GetObjectsParams params)
        returns(GetObjectsResults results) authentication required;
};
