
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
 * <p>Original spec-file type: SaveObjectsParams</p>
 * <pre>
 * Input parameters for the "save_objects" function.
 *     Required parameters:
 *     id - the numerical ID of the workspace.
 *     workspace - optional workspace name alternative to id.
 *     objects - the objects to save.
 *     
 *     The object provenance is automatically pulled from the SDK runner.
 * </pre>
 * 
 */
@JsonInclude(JsonInclude.Include.NON_NULL)
@Generated("com.googlecode.jsonschema2pojo")
@JsonPropertyOrder({
    "id",
    "workspace",
    "objects"
})
public class SaveObjectsParams {

    @JsonProperty("id")
    private Long id;
    @JsonProperty("workspace")
    private String workspace;
    @JsonProperty("objects")
    private List<ObjectSaveData> objects;
    private Map<String, Object> additionalProperties = new HashMap<String, Object>();

    @JsonProperty("id")
    public Long getId() {
        return id;
    }

    @JsonProperty("id")
    public void setId(Long id) {
        this.id = id;
    }

    public SaveObjectsParams withId(Long id) {
        this.id = id;
        return this;
    }

    @JsonProperty("workspace")
    public String getWorkspace() {
        return workspace;
    }

    @JsonProperty("workspace")
    public void setWorkspace(String workspace) {
        this.workspace = workspace;
    }

    public SaveObjectsParams withWorkspace(String workspace) {
        this.workspace = workspace;
        return this;
    }

    @JsonProperty("objects")
    public List<ObjectSaveData> getObjects() {
        return objects;
    }

    @JsonProperty("objects")
    public void setObjects(List<ObjectSaveData> objects) {
        this.objects = objects;
    }

    public SaveObjectsParams withObjects(List<ObjectSaveData> objects) {
        this.objects = objects;
        return this;
    }

    @JsonAnyGetter
    public Map<String, Object> getAdditionalProperties() {
        return this.additionalProperties;
    }

    @JsonAnySetter
    public void setAdditionalProperties(String name, Object value) {
        this.additionalProperties.put(name, value);
    }

    @Override
    public String toString() {
        return ((((((((("SaveObjectsParams"+" [id=")+ id)+", workspace=")+ workspace)+", objects=")+ objects)+", additionalProperties=")+ additionalProperties)+"]");
    }

}
