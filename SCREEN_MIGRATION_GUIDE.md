# Screen Migration Guide: Provider → Riverpod

This guide shows the pattern for migrating remaining screens from Provider to Riverpod.

## Migration Pattern

### 1. Update Imports

**Before:**
```dart
import 'package:provider/provider.dart';
import 'package:athletica/providers/auth_provider.dart';
```

**After:**
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:athletica/presentation/providers/auth_provider.dart';
```

### 2. Convert Widget Types

**Before:**
```dart
class MyScreen extends StatefulWidget {
  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context);
    // ...
  }
}
```

**After (Stateless):**
```dart
class MyScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coachAsync = ref.watch(coachProvider);
    return coachAsync.when(
      data: (coach) => /* UI */,
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => ErrorWidget(error),
    );
  }
}
```

**After (Stateful):**
```dart
class MyScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends ConsumerState<MyScreen> {
  @override
  Widget build(BuildContext context) {
    final coachAsync = ref.watch(coachProvider);
    // ...
  }
}
```

### 3. Replace Provider Access

**Before:**
```dart
final provider = Provider.of<AuthProvider>(context, listen: false);
final isLoading = provider.isLoading;
final data = provider.data;
```

**After:**
```dart
final asyncValue = ref.watch(dataProvider);
// Use asyncValue.when() or asyncValue.value
```

### 4. Update Navigation

**Before:**
```dart
Navigator.of(context).push(
  MaterialPageRoute(builder: (_) => NextScreen()),
);
```

**After:**
```dart
context.push('/next-screen');
// or
context.go('/next-screen');
```

## Screens Already Migrated

✅ `lib/screens/auth/signin_screen.dart`
✅ `lib/screens/dashboard/client_details_screen.dart`
✅ `lib/features/dashboard/clients/clients_screen.dart`

## Screens Still Needing Migration

- `lib/screens/auth/signup_screen.dart`
- `lib/screens/auth/forgot_password_screen.dart`
- `lib/screens/dashboard/plans_screen.dart`
- `lib/screens/dashboard/create_plan_screen.dart`
- `lib/screens/dashboard/client_progress_screen.dart`
- `lib/screens/dashboard/chat_screen.dart`
- `lib/features/dashboard/home/home_screen.dart`
- All other dashboard screens

## Key Riverpod Providers Available

- `coachProvider` - Current coach profile
- `clientsProvider` - List of all clients
- `clientDetailsProvider(clientId)` - Single client by ID
- `plansProvider` - List of all plans
- `planDetailsProvider(planId)` - Single plan by ID
- `authStateProvider` - Authentication state stream
- `signInProvider(params)` - Sign in operation
- `signUpProvider(params)` - Sign up operation

## Example: Complete Screen Migration

**Before (Provider):**
```dart
class ClientsScreen extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CoachProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) return CircularProgressIndicator();
        if (provider.error != null) return ErrorWidget(provider.error!);
        return ListView(children: provider.clients.map(...).toList());
      },
    );
  }
}
```

**After (Riverpod):**
```dart
class ClientsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientsAsync = ref.watch(clientsProvider);
    return clientsAsync.when(
      data: (clients) => ListView(
        children: clients.map((client) => ClientCard(client: client)).toList(),
      ),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => ErrorWidget(error),
    );
  }
}
```

