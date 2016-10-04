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
        data_json_file - the path to a JSON file containing the object data.
        
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

    /* An Object Specification (OS). Inherits from ObjectIdentity.
        Specifies which object, and which parts of that object, to retrieve
        from the Workspace Service.
        
        The fields wsid, workspace, objid, name, ver, and ref are identical to
        the ObjectIdentity fields.
        
        REFERENCE FOLLOWING:
        
        Reference following guarantees that a user that has access to an
        object can always see a) objects that are referenced inside the object
        and b) objects that are referenced in the object's provenance. This
        ensures that the user has visibility into the entire provenance of the
        object and the object's object dependencies (e.g. references).
        
        The user must have at least read access to the object specified in this
        SO, but need not have access to any further objects in the reference
        chain, and those objects may be deleted.
        
        Optional reference following fields:
        list<string> obj_ref_path - a path to the desired object from the object
            specified in this OS. In other words, the object specified in this
            OS is assumed to be accessible to the user, and the objects in
            the object path represent a chain of references to the desired
            object at the end of the object path. If the references are all
            valid, the desired object will be returned.
        
        OBJECT SUBSETS:
        
        When selecting a subset of an array in an object, the returned
        array is compressed to the size of the subset, but the ordering of
        the array is maintained. For example, if the array stored at the
        'feature' key of a Genome object has 4000 entries, and the object paths
        provided are:
            /feature/7
            /feature/3015
            /feature/700
        The returned feature array will be of length three and the entries will
        consist, in order, of the 7th, 700th, and 3015th entries of the
        original array.
        
        Optional object subset fields:
        list<string> included - the portions of the object to include
                in the object subset.
        boolean strict_maps - if true, throw an exception if the subset
            specification traverses a non-existant map key (default false)
        boolean strict_arrays - if true, throw an exception if the subset
            specification exceeds the size of an array (default true)
    */
    typedef structure {
        string workspace;
        int wsid;
        string name;
        int objid;
        int ver;
        string ref;
        list<string> obj_ref_path;
        list<string> included;
        boolean strict_maps;
        boolean strict_arrays;
    } ObjectSpecification;
    
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
        list<ObjectSpecification> objects;
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
