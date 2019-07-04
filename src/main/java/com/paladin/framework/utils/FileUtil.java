package com.paladin.framework.utils;

import java.io.IOException;
import java.nio.file.FileVisitOption;
import java.nio.file.FileVisitResult;
import java.nio.file.FileVisitor;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.attribute.BasicFileAttributes;
import java.nio.file.attribute.FileTime;
import java.util.EnumSet;

public class FileUtil {

	public static void deleteDirectoryAndDescendants(Path target, boolean ignoreError) throws IOException {
		if (Files.isDirectory(target)) {
			Files.walkFileTree(target, EnumSet.of(FileVisitOption.FOLLOW_LINKS), Integer.MAX_VALUE, new DeleteFileVisitor(ignoreError));
		} else {
			Files.delete(target);
		}
	}

	public static void deleteDirectoryAndDescendants(Path target, boolean ignoreError, int expiresMinutes) throws IOException {
		if (Files.isDirectory(target)) {
			Files.walkFileTree(target, EnumSet.of(FileVisitOption.FOLLOW_LINKS), Integer.MAX_VALUE, new DeleteFileVisitor(ignoreError));
		} else {						
			FileTime time = Files.getLastModifiedTime(target);
			if (time != null) {
				long  lastUpdateTime = System.currentTimeMillis() - expiresMinutes * 60 * 1000;
				if (time.toMillis() < lastUpdateTime) {
					Files.delete(target);
				}
			}		
		}
	}

	private static class DeleteFileVisitor implements FileVisitor<Path> {

		private boolean ignoreError = false;
		private long lastUpdateTime;
		private boolean deleteByUpdateTime;

		private DeleteFileVisitor(boolean ignoreError, int expiresMinutes) {
			this.ignoreError = ignoreError;
			this.lastUpdateTime = System.currentTimeMillis() - expiresMinutes * 60 * 1000;
			this.deleteByUpdateTime = true;
		}

		private DeleteFileVisitor(boolean ignoreError) {
			this.ignoreError = ignoreError;
			this.deleteByUpdateTime = false;
		}

		@Override
		public FileVisitResult preVisitDirectory(Path dir, BasicFileAttributes attrs) throws IOException {
			return FileVisitResult.CONTINUE;
		}

		@Override
		public FileVisitResult visitFile(Path file, BasicFileAttributes attrs) throws IOException {
			try {
				if (deleteByUpdateTime) {
					FileTime time = Files.getLastModifiedTime(file);
					if (time != null) {
						if (time.toMillis() < lastUpdateTime) {
							Files.delete(file);
						}
					}
				} else {
					Files.delete(file);
				}
			} catch (IOException e) {
				if (!ignoreError) {
					throw e;
				}
			}
			return FileVisitResult.CONTINUE;
		}

		@Override
		public FileVisitResult visitFileFailed(Path file, IOException exc) throws IOException {

			return FileVisitResult.CONTINUE;
		}

		@Override
		public FileVisitResult postVisitDirectory(Path dir, IOException exc) throws IOException {
			try {
				if (deleteByUpdateTime) {
					FileTime time = Files.getLastModifiedTime(dir);
					if (time != null) {
						if (time.toMillis() < lastUpdateTime) {
							Files.delete(dir);
						}
					}
				} else {
					Files.delete(dir);
				}
			} catch (IOException e) {
				if (!ignoreError) {
					throw e;
				}
			}
			return FileVisitResult.CONTINUE;
		}

	}
}
