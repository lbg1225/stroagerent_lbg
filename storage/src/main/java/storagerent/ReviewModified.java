package storagerent;
import lombok.Data;

@Data
public class ReviewModified extends AbstractEvent {

    private Long reviewId;
    private Long storageId;
    private Integer rate;
    private String content;
}
