package storagerent;

import javax.persistence.*;
import lombok.Data;

@Data
@Entity
@Table(name="Storageview_table")
public class Storageview {

        @Id
        @GeneratedValue(strategy=GenerationType.AUTO)
        private Long storageId;
        private String storageStatus;
        private String description;
        private Float price;
        private Long reservationId;
        private String reservationStatus;
        private Long paymentId;
        private String paymentStatus;
        private Long reviewCnt;        
}
