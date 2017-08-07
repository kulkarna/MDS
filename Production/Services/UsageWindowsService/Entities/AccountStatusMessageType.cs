namespace UsageWindowsService.Entities
{//select IsRejection, IsAcceptanceInformational, IsAcceptance, IsAcceptanceIdrAvailable, Description
    public class AccountStatusMessageType
    {
        public string Message { get; set; }
        public string Description { get; set; }
        public bool IsAcceptance { get; set; }
        public bool IsAcceptanceInformational { get; set; }
        public bool IsAcceptanceIdrAvailable { get; set; }
        public bool IsRejection { get; set; }
    }
}