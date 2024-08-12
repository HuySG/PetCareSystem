namespace Pets4lifeAPI.MailConfig
{
    public class SendMail
    {
        public static int GenerateOTP()
        {
            Random rand = new Random();
            int OTP = rand.Next(1000, 10000);
            return OTP;
        }
    }
}
