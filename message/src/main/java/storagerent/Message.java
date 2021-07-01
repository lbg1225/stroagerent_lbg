package storagerent;

import javax.persistence.*;
import lombok.*;

@Data
@Entity
@Table(name="Message_table")
public class Message {

    @Id
    @GeneratedValue(strategy=GenerationType.AUTO)
    private Long messageId;
    private Long storageId;
    private String content;
}
