package storagerent;

import storagerent.config.kafka.KafkaProcessor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cloud.stream.annotation.StreamListener;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.stereotype.Service;

@Service
public class PolicyHandler{
    @Autowired MessageRepository messageRepository;

    @StreamListener(KafkaProcessor.INPUT)
    public void wheneverReservationConfirmed_SendConfirmMsg(@Payload ReservationConfirmed reservationConfirmed){

        if(!reservationConfirmed.validate()) return;

        System.out.println("\n\n##### listener SendConfirmMsg : " + reservationConfirmed.toJson() + "\n\n");

        long storageId = reservationConfirmed.getStorageId();
        String msgString = "예약이 완료 되었습니다. Storage 번호 : [" + storageId +"]";

         // 메시지 전송
         sendMsg(storageId, msgString);
            
    }
    @StreamListener(KafkaProcessor.INPUT)
    public void wheneverReservationCancelled_SendCancelMsg(@Payload ReservationCancelled reservationCancelled){

        if(!reservationCancelled.validate()) return;

        System.out.println("\n\n##### listener SendCancelMsg : " + reservationCancelled.toJson() + "\n\n");

        long storageId = reservationCancelled.getStorageId();
        String msgString = "예약이 취소 되었습니다. Storage 번호 : [" + storageId +"]";

         // 메시지 전송
        sendMsg(storageId, msgString);
            
    }


    @StreamListener(KafkaProcessor.INPUT)
    public void whatever(@Payload String eventString){}

    private void sendMsg(long storageId, String msgString) {

        //////////////////////////////////////////////
        // roomId 룸에 대해 msgString으로 SMS를 쌓는다
        //////////////////////////////////////////////
        Message msg = new Message();
        msg.setStorageId(storageId);
        msg.setContent(msgString);

        // DB Insert
        messageRepository.save(msg);
    }

}
