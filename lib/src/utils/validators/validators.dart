class Validators{

  static String? validateEmptyField(String? value, String? fieldName){
    if(value == null || value.isEmpty){
      return '$fieldName is required';
    }
    return null;
  }

  static String? emailValidator(String? value){
    if(value == null || value.isEmpty){
      return 'Email is required';
    }
    if(!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)){
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? passwordValidator(String? value){
    if(value == null || value.isEmpty){
      return 'Password is required';
    }
    if(value.length < 6){
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  static String? confirmPasswordValidator(String? value, String? password){
    if(value == null || value.isEmpty){
      return 'Confirm password is required';
    }
    if(value != password){
      return 'Passwords do not match';
    }
    return null;
  }

  static String? nameValidator(String? value){
    if(value == null || value.isEmpty){
      return 'Name is required';
    }
    if(value.length < 3){
      return 'Name must be at least 3 characters long';
    }
    return null;
  }

  static String? phoneValidator(String? value){
    if(value == null || value.isEmpty){
      return 'Phone number is required';
    }
    if(value.length < 10){
      return 'Phone number must be at least 10 characters long';
    }

    if(!RegExp(r'^[0-9]+$').hasMatch(value)){
      return 'Please enter a valid phone number';
    }

    return null;
  }
}