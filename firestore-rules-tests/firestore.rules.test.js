import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { after, before, beforeEach, test } from 'node:test';
import {
  assertFails,
  assertSucceeds,
  initializeTestEnvironment,
} from '@firebase/rules-unit-testing';
import {
  deleteDoc,
  doc,
  getDoc,
  setDoc,
  Timestamp,
  updateDoc,
} from 'firebase/firestore';

let testEnvironment;

before(async () => {
  testEnvironment = await initializeTestEnvironment({
    projectId: 'demo-swapfy',
    firestore: {
      rules: readFileSync(new URL('../firestore.rules', import.meta.url), 'utf8'),
    },
  });
});

after(async () => {
  await testEnvironment.cleanup();
});

beforeEach(async () => {
  await testEnvironment.clearFirestore();
  await testEnvironment.withSecurityRulesDisabled(async (context) => {
    const database = context.firestore();
    await setDoc(doc(database, 'skills', 'skill-1'), {
      authorId: 'alice',
      published: true,
    });
    await setDoc(doc(database, 'conversations', 'conversation-1'), {
      participantIds: ['alice', 'bob'],
      lastMessage: 'Hello',
      updatedAt: Timestamp.now(),
    });
  });
});

test('a signed-in user cannot claim another author skill', async () => {
  const database = testEnvironment.authenticatedContext('bob').firestore();

  await assertFails(
    updateDoc(doc(database, 'skills', 'skill-1'), { authorId: 'bob' }),
  );
});

test('a skill author can delete their own skill', async () => {
  const database = testEnvironment.authenticatedContext('alice').firestore();

  await assertSucceeds(deleteDoc(doc(database, 'skills', 'skill-1')));
});

test('a participant cannot change conversation membership', async () => {
  const database = testEnvironment.authenticatedContext('alice').firestore();

  await assertFails(
    updateDoc(doc(database, 'conversations', 'conversation-1'), {
      participantIds: ['alice', 'mallory'],
    }),
  );
});

test('a participant can update conversation message metadata', async () => {
  const database = testEnvironment.authenticatedContext('alice').firestore();

  await assertSucceeds(
    updateDoc(doc(database, 'conversations', 'conversation-1'), {
      lastMessage: 'See you tomorrow',
      updatedAt: Timestamp.now(),
    }),
  );
});

test('a participant cannot send a message as another user', async () => {
  const database = testEnvironment.authenticatedContext('bob').firestore();

  await assertFails(
    setDoc(
      doc(database, 'conversations', 'conversation-1', 'messages', 'message-1'),
      {
        id: 'message-1',
        conversationId: 'conversation-1',
        senderId: 'alice',
        text: 'Spoofed sender',
        sentAt: Timestamp.now(),
        isRead: false,
      },
    ),
  );
});

test('an authenticated participant can send their own message', async () => {
  const database = testEnvironment.authenticatedContext('alice').firestore();

  await assertSucceeds(
    setDoc(
      doc(database, 'conversations', 'conversation-1', 'messages', 'message-1'),
      {
        id: 'message-1',
        conversationId: 'conversation-1',
        senderId: 'alice',
        text: 'Hello',
        sentAt: Timestamp.now(),
        isRead: false,
      },
    ),
  );
});

test('an unauthenticated user cannot read profiles', async () => {
  const database = testEnvironment.unauthenticatedContext().firestore();

  await assertFails(getDoc(doc(database, 'users', 'alice')));
});
