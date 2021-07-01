package storagerent;
import lombok.Data;

@Data
public class StorageCancelled extends AbstractEvent {

    private Long storageId;
    private String storageStatus;
    private String description;
    private Long reviewCnt;
    private String lastAction;
    private Float price;
}
