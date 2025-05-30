from rest_framework import status, generics, parsers
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.permissions import AllowAny, IsAuthenticated
from django.contrib.auth import authenticate, get_user_model
from .serializers import UserSerializer, UserRegistrationSerializer, UserLoginSerializer, TokenSerializer
from django.shortcuts import render, get_object_or_404

User = get_user_model()

class RegisterView(generics.CreateAPIView):
    """
    API view for user registration.
    """
    queryset = User.objects.all()
    permission_classes = (AllowAny,)
    serializer_class = UserRegistrationSerializer
    
    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        if not serializer.is_valid():
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        
        try:
            user = serializer.save()
            return Response({
                'message': 'Account created successfully. Please check your email to verify your account.',
                'email': user.email
            }, status=status.HTTP_201_CREATED)
        except Exception as e:
            return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)

class LoginView(APIView):
    """
    API view for user login.
    """
    permission_classes = (AllowAny,)
    serializer_class = UserLoginSerializer
    
    def post(self, request):
        serializer = self.serializer_class(data=request.data)
        serializer.is_valid(raise_exception=True)
        
        email = serializer.validated_data['email']
        password = serializer.validated_data['password']
        
        user = authenticate(request, username=email, password=password)
        
        if user is not None:
            if not user.is_email_verified:
                return Response({
                    'error': 'Please verify your email before logging in.'
                }, status=status.HTTP_401_UNAUTHORIZED)
            
            token = TokenSerializer.get_token(user)
            return Response(token, status=status.HTTP_200_OK)
        
        return Response({'error': 'Invalid credentials'}, status=status.HTTP_401_UNAUTHORIZED)

class VerifyEmailView(APIView):
    permission_classes = (AllowAny,)
    
    def get(self, request, token):
        try:
            user = get_object_or_404(User, email_verification_token=token)
            if user.is_email_verified:
                return render(request, 'email_verification.html', {
                    'success': True,
                    'message': 'Your email was already verified.'
                })
            
            user.is_email_verified = True
            user.is_active = True
            user.save()
            
            return render(request, 'email_verification.html', {
                'success': True,
                'message': 'Email verified successfully. You can now log in.'
            })
            
        except User.DoesNotExist:
            return render(request, 'email_verification.html', {
                'success': False,
                'message': 'Invalid verification token.'
            })

class UserProfileView(generics.RetrieveUpdateAPIView):
    """
    API view for user profile retrieval and update.
    """
    serializer_class = UserSerializer
    permission_classes = (IsAuthenticated,)
    parser_classes = [parsers.MultiPartParser, parsers.FormParser]

    def get_object(self):
        return self.request.user

    def perform_update(self, serializer):
        # Handle file upload separately
        profile_picture = self.request.FILES.get('profile_picture')
        if profile_picture:
            self.request.user.profile_picture = profile_picture
        serializer.save()