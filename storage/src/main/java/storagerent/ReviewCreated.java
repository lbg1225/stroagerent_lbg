
package storagerent;
import lombok.Data;

@Data
public class ReviewCreated extends AbstractEvent {

    private Long reviewId;
    private Long storageId;
    private Integer rate;
    private String content;
}

