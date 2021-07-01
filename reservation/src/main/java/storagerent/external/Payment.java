package storagerent.external;
import lombok.Data;

@Data
public class Payment {

    private Long paymentId;
    private Long reservationId;
    private Long storageId;
    private String paymentStatus;
    private Float price;
}
