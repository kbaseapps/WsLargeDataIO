
package wslargedataio;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Generated;
import com.fasterxml.jackson.annotation.JsonAnyGetter;
import com.fasterxml.jackson.annotation.JsonAnySetter;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonPropertyOrder;


/**
 * <p>Original spec-file type: ObjectSpecification</p>
 * <pre>
 * An Object Specification (OS). Inherits from ObjectIdentity.
 * Specifies which object, and which parts of that object, to retrieve
 * from the Workspace Service.
 * The fields wsid, workspace, objid, name, ver, and ref are identical to
 * the ObjectIdentity fields.
 * REFERENCE FOLLOWING:
 * Reference following guarantees that a user that has access to an
 * object can always see a) objects that are referenced inside the object
 * and b) objects that are referenced in the object's provenance. This
 * ensures that the user has visibility into the entire provenance of the
 * object and the object's object dependencies (e.g. references).
 * The user must have at least read access to the object specified in this
 * SO, but need not have access to any further objects in the reference
 * chain, and those objects may be deleted.
 * Optional reference following fields:
 * list<string> obj_ref_path - a path to the desired object from the object
 *     specified in this OS. In other words, the object specified in this
 *     OS is assumed to be accessible to the user, and the objects in
 *     the object path represent a chain of references to the desired
 *     object at the end of the object path. If the references are all
 *     valid, the desired object will be returned.
 * OBJECT SUBSETS:
 * When selecting a subset of an array in an object, the returned
 * array is compressed to the size of the subset, but the ordering of
 * the array is maintained. For example, if the array stored at the
 * 'feature' key of a Genome object has 4000 entries, and the object paths
 * provided are:
 *     /feature/7
 *     /feature/3015
 *     /feature/700
 * The returned feature array will be of length three and the entries will
 * consist, in order, of the 7th, 700th, and 3015th entries of the
 * original array.
 * Optional object subset fields:
 * list<string> included - the portions of the object to include
 *         in the object subset.
 * boolean strict_maps - if true, throw an exception if the subset
 *     specification traverses a non-existant map key (default false)
 * boolean strict_arrays - if true, throw an exception if the subset
 *     specification exceeds the size of an array (default true)
 * </pre>
 * 
 */
@JsonInclude(JsonInclude.Include.NON_NULL)
@Generated("com.googlecode.jsonschema2pojo")
@JsonPropertyOrder({
    "workspace",
    "wsid",
    "name",
    "objid",
    "ver",
    "ref",
    "obj_ref_path",
    "included",
    "strict_maps",
    "strict_arrays"
})
public class ObjectSpecification {

    @JsonProperty("workspace")
    private java.lang.String workspace;
    @JsonProperty("wsid")
    private Long wsid;
    @JsonProperty("name")
    private java.lang.String name;
    @JsonProperty("objid")
    private Long objid;
    @JsonProperty("ver")
    private Long ver;
    @JsonProperty("ref")
    private java.lang.String ref;
    @JsonProperty("obj_ref_path")
    private List<String> objRefPath;
    @JsonProperty("included")
    private List<String> included;
    @JsonProperty("strict_maps")
    private Long strictMaps;
    @JsonProperty("strict_arrays")
    private Long strictArrays;
    private Map<java.lang.String, Object> additionalProperties = new HashMap<java.lang.String, Object>();

    @JsonProperty("workspace")
    public java.lang.String getWorkspace() {
        return workspace;
    }

    @JsonProperty("workspace")
    public void setWorkspace(java.lang.String workspace) {
        this.workspace = workspace;
    }

    public ObjectSpecification withWorkspace(java.lang.String workspace) {
        this.workspace = workspace;
        return this;
    }

    @JsonProperty("wsid")
    public Long getWsid() {
        return wsid;
    }

    @JsonProperty("wsid")
    public void setWsid(Long wsid) {
        this.wsid = wsid;
    }

    public ObjectSpecification withWsid(Long wsid) {
        this.wsid = wsid;
        return this;
    }

    @JsonProperty("name")
    public java.lang.String getName() {
        return name;
    }

    @JsonProperty("name")
    public void setName(java.lang.String name) {
        this.name = name;
    }

    public ObjectSpecification withName(java.lang.String name) {
        this.name = name;
        return this;
    }

    @JsonProperty("objid")
    public Long getObjid() {
        return objid;
    }

    @JsonProperty("objid")
    public void setObjid(Long objid) {
        this.objid = objid;
    }

    public ObjectSpecification withObjid(Long objid) {
        this.objid = objid;
        return this;
    }

    @JsonProperty("ver")
    public Long getVer() {
        return ver;
    }

    @JsonProperty("ver")
    public void setVer(Long ver) {
        this.ver = ver;
    }

    public ObjectSpecification withVer(Long ver) {
        this.ver = ver;
        return this;
    }

    @JsonProperty("ref")
    public java.lang.String getRef() {
        return ref;
    }

    @JsonProperty("ref")
    public void setRef(java.lang.String ref) {
        this.ref = ref;
    }

    public ObjectSpecification withRef(java.lang.String ref) {
        this.ref = ref;
        return this;
    }

    @JsonProperty("obj_ref_path")
    public List<String> getObjRefPath() {
        return objRefPath;
    }

    @JsonProperty("obj_ref_path")
    public void setObjRefPath(List<String> objRefPath) {
        this.objRefPath = objRefPath;
    }

    public ObjectSpecification withObjRefPath(List<String> objRefPath) {
        this.objRefPath = objRefPath;
        return this;
    }

    @JsonProperty("included")
    public List<String> getIncluded() {
        return included;
    }

    @JsonProperty("included")
    public void setIncluded(List<String> included) {
        this.included = included;
    }

    public ObjectSpecification withIncluded(List<String> included) {
        this.included = included;
        return this;
    }

    @JsonProperty("strict_maps")
    public Long getStrictMaps() {
        return strictMaps;
    }

    @JsonProperty("strict_maps")
    public void setStrictMaps(Long strictMaps) {
        this.strictMaps = strictMaps;
    }

    public ObjectSpecification withStrictMaps(Long strictMaps) {
        this.strictMaps = strictMaps;
        return this;
    }

    @JsonProperty("strict_arrays")
    public Long getStrictArrays() {
        return strictArrays;
    }

    @JsonProperty("strict_arrays")
    public void setStrictArrays(Long strictArrays) {
        this.strictArrays = strictArrays;
    }

    public ObjectSpecification withStrictArrays(Long strictArrays) {
        this.strictArrays = strictArrays;
        return this;
    }

    @JsonAnyGetter
    public Map<java.lang.String, Object> getAdditionalProperties() {
        return this.additionalProperties;
    }

    @JsonAnySetter
    public void setAdditionalProperties(java.lang.String name, Object value) {
        this.additionalProperties.put(name, value);
    }

    @Override
    public java.lang.String toString() {
        return ((((((((((((((((((((((("ObjectSpecification"+" [workspace=")+ workspace)+", wsid=")+ wsid)+", name=")+ name)+", objid=")+ objid)+", ver=")+ ver)+", ref=")+ ref)+", objRefPath=")+ objRefPath)+", included=")+ included)+", strictMaps=")+ strictMaps)+", strictArrays=")+ strictArrays)+", additionalProperties=")+ additionalProperties)+"]");
    }

}
