
package storagerent;
import lombok.Data;

@Data
public class ReviewDeleted extends AbstractEvent {

    private Long reviewId;
    private Long storageId;
    private Integer rate;
    private String content;
}

