
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
 * <p>Original spec-file type: GetObjectsParams</p>
 * <pre>
 * Input parameters for the "get_objects" function.
 *     Required parameters:
 *     object_refs - a list of object references in the form X/Y/Z, where X is
 *         the workspace name or id, Y is the object name or id, and Z is the
 *         (optional) object version. In general, always use ids rather than
 *         names if possible to avoid race conditions.
 *     
 *     Optional parameters:
 *     ignore_errors - ignore any errors that occur when fetching an object
 *         and instead insert a null into the returned list.
 * </pre>
 * 
 */
@JsonInclude(JsonInclude.Include.NON_NULL)
@Generated("com.googlecode.jsonschema2pojo")
@JsonPropertyOrder({
    "objects",
    "ignore_errors"
})
public class GetObjectsParams {

    @JsonProperty("objects")
    private List<ObjectSpecification> objects;
    @JsonProperty("ignore_errors")
    private Long ignoreErrors;
    private Map<String, Object> additionalProperties = new HashMap<String, Object>();

    @JsonProperty("objects")
    public List<ObjectSpecification> getObjects() {
        return objects;
    }

    @JsonProperty("objects")
    public void setObjects(List<ObjectSpecification> objects) {
        this.objects = objects;
    }

    public GetObjectsParams withObjects(List<ObjectSpecification> objects) {
        this.objects = objects;
        return this;
    }

    @JsonProperty("ignore_errors")
    public Long getIgnoreErrors() {
        return ignoreErrors;
    }

    @JsonProperty("ignore_errors")
    public void setIgnoreErrors(Long ignoreErrors) {
        this.ignoreErrors = ignoreErrors;
    }

    public GetObjectsParams withIgnoreErrors(Long ignoreErrors) {
        this.ignoreErrors = ignoreErrors;
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
        return ((((((("GetObjectsParams"+" [objects=")+ objects)+", ignoreErrors=")+ ignoreErrors)+", additionalProperties=")+ additionalProperties)+"]");
    }

}
