import 'package:bloc/bloc.dart';
import 'package:custos/core/utils/base_state/base_state.dart';
import 'package:custos/data/models/password_entry/password_entry_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'passwords_entries_cubit.freezed.dart';
part 'passwords_entries_state.dart';

class PasswordsEntriesCubit extends Cubit<PasswordsEntriesState> {
  PasswordsEntriesCubit()
    : super(PasswordsEntriesState(passwordsEntries: BaseState.initial()));

  Future<void> getPasswordsEntries() async {
    emit(state.copyWith(passwordsEntries: BaseState.data(_passwordsEntries)));
  }
}

const _passwordsEntries = [
  PasswordEntryModel(
    name: 'Facebook',
    url: 'www.facebook.com',
    username: 'famarrero',
    password: '12345678f',
    note: 'This is the facebook password',
    groupId: 'awfb',
  ),

  PasswordEntryModel(
    name: 'Instagram',
    url: 'www.instagram.com',
    username: 'famarrero',
    password: '12345678f',
    note: 'This is the instagram password',
    groupId: 'awfb',
  ),

  PasswordEntryModel(
    name: 'Personal Gmail',
    url: 'www.gmail.com',
    username: 'famarrero@gmail.com',
    password: '12345678f',
    note: 'This is the personal gmail password',
    groupId: 'awfb',
  ),

  PasswordEntryModel(
    name: 'Facebook',
    url: 'www.facebook.com',
    username: 'famarrero',
    password: '12345678f',
    note: 'This is the facebook password',
    groupId: 'awfb',
  ),

  PasswordEntryModel(
    name: 'Instagram',
    url: 'www.instagram.com',
    username: 'famarrero',
    password: '12345678f',
    note: 'This is the instagram password',
    groupId: 'awfb',
  ),

  PasswordEntryModel(
    name: 'Personal Gmail',
    url: 'www.gmail.com',
    username: 'famarrero@gmail.com',
    password: '12345678f',
    note: 'This is the personal gmail password',
    groupId: 'awfb',
  ),

  PasswordEntryModel(
    name: 'Facebook',
    url: 'www.facebook.com',
    username: 'famarrero',
    password: '12345678f',
    note: 'This is the facebook password',
    groupId: 'awfb',
  ),

  PasswordEntryModel(
    name: 'Instagram',
    url: 'www.instagram.com',
    username: 'famarrero',
    password: '12345678f',
    note: 'This is the instagram password',
    groupId: 'awfb',
  ),

  PasswordEntryModel(
    name: 'Personal Gmail',
    url: 'www.gmail.com',
    username: 'famarrero@gmail.com',
    password: '12345678f',
    note: 'This is the personal gmail password',
    groupId: 'awfb',
  ),

  PasswordEntryModel(
    name: 'Facebook',
    url: 'www.facebook.com',
    username: 'famarrero',
    password: '12345678f',
    note: 'This is the facebook password',
    groupId: 'awfb',
  ),

  PasswordEntryModel(
    name: 'Instagram',
    url: 'www.instagram.com',
    username: 'famarrero',
    password: '12345678f',
    note: 'This is the instagram password',
    groupId: 'awfb',
  ),

  PasswordEntryModel(
    name: 'Personal Gmail',
    url: 'www.gmail.com',
    username: 'famarrero@gmail.com',
    password: '12345678f',
    note: 'This is the personal gmail password',
    groupId: 'awfb',
  ),

  PasswordEntryModel(
    name: 'Facebook',
    url: 'www.facebook.com',
    username: 'famarrero',
    password: '12345678f',
    note: 'This is the facebook password',
    groupId: 'awfb',
  ),

  PasswordEntryModel(
    name: 'Instagram',
    url: 'www.instagram.com',
    username: 'famarrero',
    password: '12345678f',
    note: 'This is the instagram password',
    groupId: 'awfb',
  ),

  PasswordEntryModel(
    name: 'Personal Gmail',
    url: 'www.gmail.com',
    username: 'famarrero@gmail.com',
    password: '12345678f',
    note: 'This is the personal gmail password',
    groupId: 'awfb',
  ),

  PasswordEntryModel(
    name: 'Facebook',
    url: 'www.facebook.com',
    username: 'famarrero',
    password: '12345678f',
    note: 'This is the facebook password',
    groupId: 'awfb',
  ),

  PasswordEntryModel(
    name: 'Instagram',
    url: 'www.instagram.com',
    username: 'famarrero',
    password: '12345678f',
    note: 'This is the instagram password',
    groupId: 'awfb',
  ),

  PasswordEntryModel(
    name: 'Personal Gmail',
    url: 'www.gmail.com',
    username: 'famarrero@gmail.com',
    password: '12345678f',
    note: 'This is the personal gmail password',
    groupId: 'awfb',
  ),

  PasswordEntryModel(
    name: 'Facebook',
    url: 'www.facebook.com',
    username: 'famarrero',
    password: '12345678f',
    note: 'This is the facebook password',
    groupId: 'awfb',
  ),

  PasswordEntryModel(
    name: 'Instagram',
    url: 'www.instagram.com',
    username: 'famarrero',
    password: '12345678f',
    note: 'This is the instagram password',
    groupId: 'awfb',
  ),

  PasswordEntryModel(
    name: 'Personal Gmail',
    url: 'www.gmail.com',
    username: 'famarrero@gmail.com',
    password: '12345678f',
    note: 'This is the personal gmail password',
    groupId: 'awfb',
  ),
];
