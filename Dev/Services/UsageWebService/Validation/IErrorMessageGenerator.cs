﻿using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace UsageWebService.Validation
{
    public interface IErrorMessageGenerator
    {
        string GenerateErrorMessage(string operationName, IEnumerable<ValidationResult> validationResults); 
    }
}